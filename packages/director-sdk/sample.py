# install package like so:
# pip install -v  git+https://github.com/sanderegg/osparc-simcore.git@director-sdk#subdirectory=packages/director-sdk/python

import asyncio
import simcore_director_sdk

from simcore_director_sdk.rest import ApiException

SERVICE_KEY = "simcore/services/dynamic/3d-viewer"
SERVICE_UUID = "testing6"

# create an instance of the API class
configuration = simcore_director_sdk.Configuration()
configuration.host = configuration.host.format(host="osparc01.speag.com", port="8001", version="v1")
api_instance = simcore_director_sdk.UsersApi(simcore_director_sdk.ApiClient(configuration))

async def get_root():
    try:
        api_response = await api_instance.root_get()    
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)

async def get_services_details():
    try:
        api_response = await api_instance.services_get()
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)

async def get_service_details():
    try:
        api_response = await api_instance.services_by_key_version_get(service_key=SERVICE_KEY, service_version="1.0.1")
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)


async def start_service():
    try:
        api_response = await api_instance.running_interactive_services_post(service_key=SERVICE_KEY, service_uuid=SERVICE_UUID)
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)

async def get_service():
    try:
        api_response = await api_instance.running_interactive_services_get(service_uuid=SERVICE_UUID)
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)
        
async def stop_service():
    try:
        api_response = await api_instance.running_interactive_services_delete(service_uuid=SERVICE_UUID)
        print(api_response)
    except ApiException as e:
        print("Exception when calling UserApi->root_get: %s\n" % e)

async def test_api():
    await get_root()
    await get_services_details()
    await get_service_details()
    await start_service()
    await get_service()
    await stop_service()
    print("do work")

loop = asyncio.get_event_loop()
# asyncio.ensure_future(test_api())
try:
    loop.run_until_complete(test_api())
finally:
    # loop.close()
    pass