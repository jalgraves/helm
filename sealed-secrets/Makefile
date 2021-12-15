.PHONY: all test clean

context ?= ${CONTEXT}

deps:
	helm dependencies update

install:
	kubectl config use-context $(context)
	helm upgrade --install sealed-secrets . \
		--namespace kube-system \
		--debug