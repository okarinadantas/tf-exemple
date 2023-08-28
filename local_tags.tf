tags {
  owner = "Tags to apply to the Azure Resource Group."
  type        = map(string)
  default     = {
    environment = "dev"
    department  = "engineering"
  }
}