cpman-up:
	./scripts/cpman-up.sh
cpman-down:
	./scripts/cpman-down.sh
login-sp:
	./scripts/login-sp.sh

login: login-sp
cpman: cpman-up check-cpman

cpman-serial:
	./scripts/cpman-serial.sh
serial: cpman-serial

check-cpman:
	./scripts/cpman-check.sh
cpman-check: check-cpman

get-sp:
	./scripts/get-sp.sh
make sp: get-sp

sp-down:
	./scripts/sp-down.sh

cleanup: cpman-down sp-down

	