dev:
	@git pull
	@rm -rf .terraform
	@terraform init -backend-config=env-dev/state.tfvars
	@terraform plan -var-file=env-dev/main.tfvars
	@terraform apply -auto-approve -var-file=env-dev/main.tfvars

dev-destroy:
	@rm -rf .terraform
	@terraform init -backend-config=env-dev/state.tfvars
	@terraform destroy -auto-approve -var-file=env-dev/main.tfvars

prod:
	@git pull
	@rm -rf .terraform
	@terraform init -backend-config=env-prod/state.tfvars
	@@terraform plan -var-file=env-prod/main.tfvars
	@terraform apply -auto-approve -var-file=env-prod/main.tfvars

prod-destroy:
	@rm -rf .terraform
	@terraform init -backend-config=env-prod/state.tfvars
	@terraform destroy -auto-approve -var-file=env-prod/main.tfvars