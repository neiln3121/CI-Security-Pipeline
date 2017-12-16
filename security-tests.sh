ZAP_PORT=8090
echo "::running security tests"
rm -rf $PWD/security
rm -rf $PWD/artifacts
mkdir -p $PWD/security $PWD/artifacts;

echo "::running zap tests"
docker pull owasp/zap2docker-weekly
echo ":::Baseline scan"
docker run --net security-tests --name zap -v $PWD/security:/zap/wrk/:rw -t owasp/zap2docker-weekly zap-baseline.py \
    -t http://webapp:50000 -g gen.conf -r testreport.html
#docker run --rm --net security-tests -t owasp/zap2docker-weekly zap-cli quick-scan --self-contained --start-options '-config api.disablekey=true' https://webapp:50000; echo $?

echo "::running arachni tests"
docker pull ahannigan/docker-arachni
docker run --rm \
    --net security-tests \
    -v $PWD/security:/arachni/reports  ahannigan/docker-arachni \
    bin/arachni http://webapp:50000 \
    --browser-cluster-pool-size=1 \
    --output-verbose \
    --report-save-path=reports/result.io.afr;
docker run \
    --net security-tests \
    --name=arachni_report  \
    -v $PWD/security:/arachni/reports ahannigan/docker-arachni:rw \
    bin/arachni_reporter reports/result.io.afr \
    --reporter=html:outfile=reports/arachni-report.html.zip;
#docker cp arachni_report:/arachni/reports/arachni-report.html.zip $PWD/security;
unzip $PWD/security/arachni-report.html.zip -d $PWD/artifacts
