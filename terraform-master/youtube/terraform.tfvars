#subnet-cidr = "10.0.1.0/24"  #string - 1st Way

#subnet-cidr = ["10.0.2.0/24", "10.0.3.0/24"] #list - 2nd Way


subnet-cidr = [{cidr_block = "10.0.1.0/24", name = "subnet-1"}, {cidr_block = "10.0.2.0/24", name = "subnet-2"}]  # Both - 3rd Way
