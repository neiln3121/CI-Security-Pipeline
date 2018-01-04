echo "::running security tests"
rm -rf $PWD/security $PWD/artifacts;
mkdir -m777 -p $PWD/security $PWD/artifacts;

echo "::running zap tests"
echo ":::Baseline scan"
docker run --rm -t \
    --link webapp \
    -v $PWD/artifacts:/zap/wrk:rw \
    owasp/zap2docker-weekly zap-baseline.py -t http://webapp:8080/bodgeit -g gen.conf -r zap-report.html;

echo "::running arachni tests"
docker run --rm \
    --link webapp \
    -v $PWD/security:/arachni/reports \
    ahannigan/docker-arachni bin/arachni http://webapp:8080/bodgeit --report-save-path=reports/result.io.afr;
docker run --rm \
    -v $PWD/security:/arachni/reports \
    ahannigan/docker-arachni bin/arachni_reporter reports/result.io.afr --reporter=html:outfile=reports/arachni-report.html.zip --reporter=xunit:outfile=xunit_report.xml;
unzip $PWD/security/arachni-report.html.zip -d $PWD/artifacts;

