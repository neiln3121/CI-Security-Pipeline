docker pull psiinon/bodgeit
docker network create security-tests
run --rm --net security-tests --name webapp -p 50000:8080 -i -t psiinon/bodgeit'