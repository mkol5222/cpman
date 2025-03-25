

locals {
    # read sp.json
    spfile = jsondecode(file("${path.module}/../sp.json"))
    envId = local.spfile.envId
}