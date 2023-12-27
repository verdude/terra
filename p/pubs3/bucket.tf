module "pub-bucket" {
  source = "../../aws/pubs3"

  environment = "test"
  object_name = "thingy"
  folder      = "thingies"
}

