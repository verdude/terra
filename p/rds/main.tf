data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

// resources
module "vpc" {
  source = "../../aws/vpc/main"
}

module "sec_groups" {
  source = "../../aws/sec_groups"
  vpc_id = module.vpc.vpc_id
}

module "keys" {
  source   = "../../aws/keys"
}

module "ec2" {
  source = "../../aws/ec2"

  vpc_sec_gids = module.sec_groups.sec_group_ids
  vpc_id       = module.vpc.vpc_id
  key_name     = module.keys.key_name
  ami          = data.aws_ami.ubuntu.id
  subnet_id    = module.vpc.p_subnet_id
  igw          = module.vpc.igw
  size         = "t3.medium"
}

resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet"
  subnet_ids = [module.vpc.p_subnet_id, module.vpc.p2_subnet_id]

  tags = {
    Name = "My first DB subnet group"
  }
}

resource "aws_rds_cluster" "postgresql" {
  # default settings
  cluster_identifier      = "aurora-pg-dev"
  engine                  = "aurora-postgresql"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  master_username         = "foo_"
  master_password         = "barneystins"

  # multi az settings
  # Not applicable to aurora-postgresql
  #storage_type              = "io1"
  #allocated_storage         = 50
  #iops                      = 1000

  # optional settings
  vpc_security_group_ids = module.sec_groups.sec_group_ids
  db_subnet_group_name = aws_db_subnet_group.default.name
  deletion_protection = false
  database_name = "persons"
  port = 5432
  engine_version = "13.8"
  engine_mode = "provisioned"
  storage_encrypted = true
  skip_final_snapshot = true

  tags = {
    name = "guru",
    env = "test",
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "pg1"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
}
