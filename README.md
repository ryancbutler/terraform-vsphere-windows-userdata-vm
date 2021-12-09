# Creates a Windows VM with vSphere guestinfo.userdata bootstrap
VMware has capability to leverage **GuestInfo** attributes which allow passing of **Metadata** and **Userdata** blobs that can be used for [Cloud-init](https://github.com/canonical/cloud-init/blob/main/doc/rtd/topics/datasources/vmware.rst). In very simple terms, once the machine boots it looks up these these values via VM tools and executes the declared YAML file using Cloud-Init. This post covers leveraging these attributes for Windows to bootstrap the operating system with a custom PowerShell script.

If you haven't started using Cloud-Init on your Linux templates with vSphere now is the time. Unfortunately, this leaves Windows out in the cold since Cloud-Init is Linux only. While investigating a solution with Windows I did find [Cloudbase-init](https://cloudbase-init.readthedocs.io/en/latest/) which looked promising at first, but soon found it didn't have any native capability of joining a Windows domain and had a lot of strange timing issues. I decided to dump Cloudbase-init and figure something else out.

## Current Process
If you ever tried to use the **run-once** portion of a Windows customization you know it's extremely limited in what you can run. Most of the time you can run a few basic commands or maybe a PowerShell script that is already included within the image but doesn't offer a lot. Since these commands are run from the Sysprep process the commands become stored in the `unattend.xml` file stored in `C:\Windows\Panther` which could contain secrets being passed into any external command (e.g. domain join credentials).

## Solution
To prevent the need for an external script or handling of the unattend.xml file I decided to leverage the metadata attribute to store my PowerShell script. The script gets rendered via Terraform to allow variable substitution then converted to base64 and finally being set in the attribute. The main components of the process:


### PowerShell Template
The `bootstrap.ps1` script uses variable substitution to render the script with any needed data for the VM such as passwords and domain info. Anything with `{var}` gets replaced via Terraform.
 
For example, the `bootstrap.ps1` template contains the following code:

```PowerShell
#Add to domain
write-host "Add to domain"
$domain = "${addomain}"
$password = "${adpass}" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\${aduser}" 
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Add-Computer -DomainName $domain -OUPath "${adou}" -Credential $credential
```

Then Terraform renders the file with the **data** block within `main.tf`:
```terraform
data "template_file" "init" {
  template = file("${path.module}/templates/bootstrap.ps1")
  vars = {
    adpass   = var.ADPass
    adou     = var.ADOU
    aduser   = var.ADUser
    addomain = var.ADDomain
  }
}
```

### Setting Attribute
Now that the script is rendered the VM attribute needs to be set.

In the Terraform code it's done with the `extra_config` block in the `vsphere_virtual_machine` resource within `main.tf`:
```terraform
extra_config = {
    "guestinfo.userdata"          = base64encode(data.template_file.init.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }
```

### Running the code
With the attribute set, we need to execute it on boot. To do this I'm using the run-once command from the Windows customization spec to pull down the attribute blob using the **rpctool.exe** that comes with VMware tools (no extra install needed), convert the base64 to PowerShell then execute the script which is being set in the `vsphere_virtual_machine` resource as you can see here in the `run_once_command_list` within `main.tf`:

```terraform
clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = false
    customize {
      windows_options {
        computer_name    = var.vm_name
        admin_password   = var.vm_password == "" ? random_password.password.result : var.vm_password
        workgroup        = "WORKGROUP"
        auto_logon       = true
        auto_logon_count = 1
        time_zone        = var.vm_timezone
        run_once_command_list = [
          "powershell \"cd \"$env:ProgramFiles\\VMware\\VMware~1\";[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($(.\\rpctool.exe \\\"info-get guestinfo.userdata\\\")))|out-file C:\\bootstrap.ps1\"",
          "cmd.exe /C Powershell.exe -ExecutionPolicy Bypass -File C:\\bootstrap.ps1"
        ]

      }

      network_interface {
        ipv4_address    = var.vm_ip
        ipv4_netmask    = var.vm_netmask
        dns_server_list = var.vm_dns_servers
        dns_domain      = var.vm_dns_domain
      }

      ipv4_gateway = var.vm_gateway
    }
  }
```

It's important to have `auto_logon_count` set to `1` so the VM logs in after the Sysprep process to kickoff the command.

### Cleaning up
In order not to leak secrets in either the attribute or script I do the following as part of my bootstrap process in the PowerShell script.

- Clear out the metadata attribute with rpctool so the base64 blob is deleted (notice two spaces at end)
- Delete the created PS1 file

```powershell
#Clear userdata
write-host "Clear userdata"
set-location "$env:ProgramFiles\VMware\VMware~1\"
.\rpctool.exe "info-set guestinfo.userdata  "

#Remove Script
write-host "Remove Script"
Remove-Item -Path "C:\bootstrap.ps1" -Force
``` 