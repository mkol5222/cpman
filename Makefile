cpman-up:
	./scripts/cpman-up.sh
cpman-down:
	./scripts/cpman-down.sh
login-sp:
	./scripts/login-sp.sh

login: login-sp
cpman: cpman-up

cpman-serial:
	./scripts/cpman-serial.sh
serial: cpman-serial

check-cpman:
	./scripts/cpman-check.sh

	