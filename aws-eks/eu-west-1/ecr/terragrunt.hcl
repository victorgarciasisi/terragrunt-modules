include "root" {
	path = find_in_parent_folders()
}

dependency "iam" {
	config_path = "../iam"
}

locals {
	config = yamldecode(file(find_in_parent_folders("config.yaml")))
}