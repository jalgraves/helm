.PHONY: all test clean

name ?= contact-api
image ?= contact_api
tag ?= $(shell grep 'appVersion:' contact_api/Chart.yaml | cut -f 2 -d' ')
port ?= 5012
context ?= beantown
email_recipient ?= ${CONTACT_API_EMAIL_RECIPIENT}
second_recipient ?= ${CONTACT_API_EMAIL_SECOND_RECIPIENT}
ingress_enabled ?= false
ingress_host ?= ${CONTACT_API_INGRESS_HOST}
slack_user ?= ${CONTACT_API_SLACK_WEBHOOK_USER}
slack_channel ?= ${CONTACT_API_SLACK_WEBHOOK_CHANNEL}

package:
		helm package .

clean:
		rm *.tgz || true

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install $(name) . \
			--set global.env=dev \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Never \
			--set db.host=${POSTGRES_IP} \
			--set db.port=32432 \
			--debug

install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--set global.env=prod \
			--set ingressHost=$(ingress_host) \
			--set emailRecipient=$(email_recipient) \
			--set secondEmailRecipient=$(second_recipient) \
			--set slackUser=$(slack_user) \
			--set slackChannel=$(slack_channel) \
			--set ingress.enabled=$(ingress_enabled) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set global.env=$(env) \
			--set ingressHost=$(ingress_host) \
			--set emailRecipient=$(email_recipient) \
			--set secondEmailRecipient=$(second_recipient) \
			--set slackUser=$(slack_user) \
			--set slackChannel=$(slack_channel) \
			--set ingress.enabled=true \
			--debug

port_forward:
		kubectl port-forward --namespace default svc/$(name) $(port):$(port) &
