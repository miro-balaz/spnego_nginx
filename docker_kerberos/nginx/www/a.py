import requests
import logging

from requests_gssapi import HTTPSPNEGOAuth

 
logging.basicConfig(level=logging.DEBUG)


auth= HTTPSPNEGOAuth()

d = requests.get('http://ngserv',auth=auth)
print(d)