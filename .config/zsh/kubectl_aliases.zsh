# Use context
# Usage: k get pods
alias k='kubectl'

# What environment am I in?
alias gc='kubectl config get-contexts'

# Helm status to see deployment
hs() {
  context=$(kubectl config current-context)
  application=$1
  helm status ${context}-${application}
}

cc() {
  trap 'exit' INT
  OUTPUT=$(kubectl config get-contexts -o name | fzf)
  echo "${OUTPUT}"

	kubectl config use-context $OUTPUT
}

# Tail logs for pods matching string
# More docs: https://github.com/johanhaleby/kubetail
kl() {
	kubetail $1
}

# Returns the helm status of the current deployment
# Usage: hs pony
hs() {
	context=$(kubectl config current-context)
	helm status ${context}-${1}
}

# Returns the helm status for helm 3 deployments
# Usage: hh pony
hh() {
	context=$(kubectl config current-context)
	helm get manifest ${context}-${1} | kubectl get -o wide -f -
	echo ""
	kubectl get pods | grep ${1}
}

# The ks & ke commands are typically used in conjunction with the hs command.
# hs will return the pod names you would use with the ks/ke commands
# for example: hs pony
# returns the helm deploy for pony and we want to ssh ( exec ) into the console
# look for the console pod under v1/Pod section: pony-console-858fdbc4bf-7jw6q
# Now we can do: ke pony-console-858fdbc4bf-7jw6q which would give us the bash prompt
# inside the console


# Returns configuration details about the pod
# Usage: ks pony-console-858fdbc4bf-7jw6q
ks() {
	kubectl describe pods $1 | grep -w "Name:"
}

# Execs into a pod ( SSH )
# Usage: ke pony-console-858fdbc4bf-7jw6q
ke() {
	kubectl exec -it $1 -- /bin/bash
}

# Pass the ENV VAR you are wanting to find across all apps as a parameter
# and will print out variable from each app in that namespace
# Usage: kv DATABASE
kv() {
	for i in $(kubectl get configmaps | grep config | awk '{ print $1 }'); do echo $i; kubectl get configmap $i -o yaml | grep $1; done
}

# Exec into the console pod directly
# Usage: kc pony
kc() {
	for i in $(kubectl get pods | grep ${1}-console | awk '{ print $1 }'); do kubectl exec -it $i -- /bin/bash; done
}

