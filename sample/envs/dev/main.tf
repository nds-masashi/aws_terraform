module "main" {
  source = "../../modules/app"

  resourceName = "user"
  email        = "user@sample.co.jp"
  domain       = "mail.sample.co.jp"
  user         = "xxxxx"
  pass         = "xxxxx"
}
