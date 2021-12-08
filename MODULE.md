## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2.0 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | ~> 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | >= 2.2.0 |
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | ~> 2.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vsphere_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.metadata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_resource_pool.pool](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |
| [vsphere_virtual_machine.template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ADDomain"></a> [ADDomain](#input\_ADDomain) | Domain to join. | `string` | n/a | yes |
| <a name="input_ADOU"></a> [ADOU](#input\_ADOU) | Which OU to place the server in | `string` | n/a | yes |
| <a name="input_ADPass"></a> [ADPass](#input\_ADPass) | Password info to join domain | `string` | n/a | yes |
| <a name="input_ADUser"></a> [ADUser](#input\_ADUser) | Login info to join domain | `string` | n/a | yes |
| <a name="input_vm_annotation"></a> [vm\_annotation](#input\_vm\_annotation) | Note to apply to VM | `string` | `"BUILT BY TERRAFORM"` | no |
| <a name="input_vm_cpu"></a> [vm\_cpu](#input\_vm\_cpu) | Number of CPUS to assign to VM | `number` | `2` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Disk size for OS disk (IN GB) | `number` | `60` | no |
| <a name="input_vm_disks"></a> [vm\_disks](#input\_vm\_disks) | List of extra disks to create | <pre>map(object({<br>    size        = number<br>    thinprov    = bool<br>    unit_number = number<br>  }))</pre> | `{}` | no |
| <a name="input_vm_dns_domain"></a> [vm\_dns\_domain](#input\_vm\_dns\_domain) | DNS Domain | `string` | n/a | yes |
| <a name="input_vm_dns_servers"></a> [vm\_dns\_servers](#input\_vm\_dns\_servers) | DNS Servers to use | `list(string)` | n/a | yes |
| <a name="input_vm_folder"></a> [vm\_folder](#input\_vm\_folder) | Folder path to place VM | `string` | `null` | no |
| <a name="input_vm_gateway"></a> [vm\_gateway](#input\_vm\_gateway) | Gateway of linux VM | `string` | n/a | yes |
| <a name="input_vm_ip"></a> [vm\_ip](#input\_vm\_ip) | IP of linux VM | `string` | n/a | yes |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Amount of RAM to assign to VM (IN MB) | `number` | `4096` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Name for linux VM | `string` | n/a | yes |
| <a name="input_vm_netmask"></a> [vm\_netmask](#input\_vm\_netmask) | Subnet mask of VM network | `number` | n/a | yes |
| <a name="input_vm_network"></a> [vm\_network](#input\_vm\_network) | vsphere network for deployed vm | `string` | n/a | yes |
| <a name="input_vm_password"></a> [vm\_password](#input\_vm\_password) | Password for linux VM (LEAVE BLANK TO GENERATE) | `string` | `""` | no |
| <a name="input_vm_thinprov"></a> [vm\_thinprov](#input\_vm\_thinprov) | Thin provision OS disk? | `bool` | `true` | no |
| <a name="input_vm_timezone"></a> [vm\_timezone](#input\_vm\_timezone) | TimeZone to use for deployed machines (DEFAULT CENTRAL) | `number` | `"020"` | no |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | vsphere datacenter | `string` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | vsphere datastore to deploy | `string` | n/a | yes |
| <a name="input_vsphere_rp"></a> [vsphere\_rp](#input\_vsphere\_rp) | vsphere resource pool | `string` | n/a | yes |
| <a name="input_vsphere_template"></a> [vsphere\_template](#input\_vsphere\_template) | vsphere template name or vm to clone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_ip"></a> [vm\_ip](#output\_vm\_ip) | IP address of VM |
| <a name="output_vm_password"></a> [vm\_password](#output\_vm\_password) | Local admin password of VM |
