echo "::running security tests"
rm -rf $PWD/tmp $PWD/html_reports;
mkdir -m777 -p $PWD/tmp $PWD/html_reports;

echo "::running zap tests"
docker pull owasp/zap2docker-weekly:latest
echo ":::Baseline scan"
docker run --rm -t \
    --link webapp \
    -v $PWD/tmp:/zap/wrk:rw \
    owasp/zap2docker-weekly zap-baseline.py -t http://webapp:8080/bodgeit -g gen.conf -r zap-report.html;
mv $PWD/tmp/zap-report.html $PWD/html_reports;

echo "::running arachni tests"
docker pull ahannigan/docker-arachni:latest
docker run --rm \
    --link webapp \
    -v $PWD/tmp:/arachni/reports \
    ahannigan/docker-arachni bin/arachni http://webapp:8080/bodgeit --report-save-path=reports/result.io.afr;
docker run --rm \
    -v $PWD/tmp:/arachni/reports \
    ahannigan/docker-arachni bin/arachni_reporter reports/result.io.afr --reporter=html:outfile=reports/arachni-report.html.zip;
unzip $PWD/tmp/arachni-report.html.zip -d $PWD/html_reports;

