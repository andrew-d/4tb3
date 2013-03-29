.PHONY: check check_xml check_xsd check_together


check: check_xml check_xsd check_together


check_xml: test.xml
	@echo '---------------- Validate XML ----------------'
	@curl -H 'Content-Type: application/xml' -d @test.xml http://www.utilities-online.info/backend/xml/wellformed
	@echo ''

check_xsd: address.xsd
	@echo '---------------- Validate XSD ----------------'
	@curl -H 'Content-Type: application/xml' -d @address.xsd http://www.utilities-online.info/backend/xsd/validateXSD
	@echo ''

check_together: test.xml address.xsd
	@echo '---------- Validate XSD against XML ----------'
	@echo "{ 'xml': '\c" > /tmp/send.json
	@cat test.xml | base64 | tr -d '\n' >> /tmp/send.json
	@echo "', 'xsd': '\c" >> /tmp/send.json
	@cat address.xsd | base64 | tr -d '\n' >> /tmp/send.json
	@echo "'}\c" >> /tmp/send.json
	@curl -H 'Content-Type: application/json' -d @/tmp/send.json http://www.utilities-online.info/backend/xsd/validate
	@echo ''
