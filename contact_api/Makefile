.PHONY: all test clean

name ?= contact-api
image ?= contact_api
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= 5012
context ?= beantown
email_recipient ?= ${CONTACT_API_EMAIL_RECIPIENT}
second_recipient ?= ${CONTACT_API_EMAIL_SECOND_RECIPIENT}
ingress_enabled ?= false
ingress_host ?= ${CONTACT_API_INGRESS_HOST}
slack_user ?= ${CONTACT_API_SLACK_WEBHOOK_USER}
slack_channel ?= ${CONTACT_API_SLACK_WEBHOOK_CHANNEL}

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else ifeq ($(env),prod)
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
else
	@echo "No Env specified!"
	exit 1
endif

clean:
		rm *.tgz || true

install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=$(env) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--namespace $(namespace) \
			--set global.env=$(env) \
			--debug

port_forward:
		kubectl port-forward --namespace $(namespace) svc/$(name) $(port):$(port)

secret:
	kubectl create secret generic contact-api-creds \
		--namespace $(namespace) \
		--from-literal=aws_access_key_id="${AWS_ACCESS_KEY_ID}" \
		--from-literal=aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}" \
		--from-literal=aws_default_region="${AWS_DEFAULT_REGION}" \
		--from-literal=email_recipient="${EMAIL_RECIPIENT}" \
		--from-literal=second_email_recipient="${SECOND_EMAIL_RECIPIENT}" \
		--from-literal=slack_channel="${SLACK_CHANNEL}" \
		--from-literal=slack_user="${SLACK_USER}" \
		--from-literal=slack_webhook_url="${SLACK_WEBHOOK_URL}"
