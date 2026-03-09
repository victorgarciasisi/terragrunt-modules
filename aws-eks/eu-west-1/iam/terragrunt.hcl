include "root" {
	path = find_in_parent_folders()
}

locals {
	config = yamldecode(file(find_in_parent_folders("config.yaml")))
}
