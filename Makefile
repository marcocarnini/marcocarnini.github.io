all:
	eval `ssh-agent`
	ssh-add ~/.ssh/privato
