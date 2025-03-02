Terraform
https://developer.hashicorp.com/terraform/install

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

brew install tfenv
tfenv list-remote
tfenv install 1.10.5
tfenv list
tfenv use 1.10.5
tfenv pin

terraform -v
terraform fmt --recursive

brew install tflint
touch .tflint.hcl

plugin "terraform" {
    enabled = true
    preset = "recommended"
}
plugin "aws" {
    enabled = true
    version = "0.35.0"
    source = "github.com/terraform-linters/tflint-ruleset-aws"
}

tflint --init
tflint --recursive

brew install trivy
trivy config .

cd ./envs/dev

terraform init
terraform plan
terraform apply
terraform destroy

terraform init --upgrade

-----
コマンド補完を有効にする
https://docs.aws.amazon.com/ja_jp/cli/v1/userguide/cli-configure-completion.html

complete -C '/usr/local/bin/aws_completer' aws