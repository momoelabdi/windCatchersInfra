

module "eks" {
    source = "terraform-modules/eks"
}


module "networking" {
    source = "terraform-modules/networking"
}
