# Example SES Email Identity
resource "aws_ses_email_identity" "ses" {
  email = var.email
}

resource "aws_ses_domain_mail_from" "mail" {
  domain           = aws_ses_email_identity.ses.email
  mail_from_domain = var.domain
}
