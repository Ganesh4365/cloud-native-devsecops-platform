.PHONY: test lint build scan deploy tf-init tf-plan tf-apply

test:
	pytest app/test_main.py -v

lint:
	flake8 app --count --statistics

build:
	docker build -t cloud-native-app:latest .

scan:
	trivy image --severity HIGH,CRITICAL cloud-native-app:latest

tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply -auto-approve
