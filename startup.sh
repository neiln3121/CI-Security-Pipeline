docker pull psiinon/bodgeit
docker network create security-tests
docker run --rm --net security-tests --name webapp -p 50000:8080 psiinon/bodgeit
