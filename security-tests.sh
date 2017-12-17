ZAP_PORT=8090
echo "::running security tests"
rm -rf $PWD/security
rm -rf $PWD/artifacts
mkdir -m775 -p $PWD/security $PWD/artifacts;

echo "::running zap tests"
docker pull owasp/zap2docker-weekly
echo ":::Baseline scan"
docker run --rm -t --name zap --link webapp -v $PWD/security:/zap/wrk:rw owasp/zap2docker-weekly zap-baseline.py \
    -t http://webapp:8080/bodgeit -g gen.conf -r zap-report.html
mv $PWD/security/zap-report.html $PWD/artifacts;

echo "::running arachni tests"
docker pull ahannigan/docker-arachni
docker run --rm \
    --link webapp \
    -v $PWD/security:/arachni/reports  ahannigan/docker-arachni \
    bin/arachni http://webapp:8080/bodgeit \
    --browser-cluster-pool-size=1 \
    --report-save-path=reports/result.io.afr;
docker run --rm \
    --name=arachni_report  \
    -v $PWD/security:/arachni/reports ahannigan/docker-arachni \
    bin/arachni_reporter reports/result.io.afr \
    --reporter=html:outfile=reports/arachni-report.html.zip;
unzip $PWD/security/arachni-report.html.zip -d $PWD/artifacts

