# coding: utf-8

from datetime import date, datetime

from typing import List, Dict, Type

from .base_model_ import Model
from .inline_response200_data import InlineResponse200Data
from .. import util


class HealthCheckEnveloped(Model):
    """NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).

    Do not edit the class manually.
    """

    def __init__(self, data: InlineResponse200Data=None, error: object=None):
        """HealthCheckEnveloped - a model defined in OpenAPI

        :param data: The data of this HealthCheckEnveloped.
        :param error: The error of this HealthCheckEnveloped.
        """
        self.openapi_types = {
            'data': InlineResponse200Data,
            'error': object
        }

        self.attribute_map = {
            'data': 'data',
            'error': 'error'
        }

        self._data = data
        self._error = error

    @classmethod
    def from_dict(cls, dikt: dict) -> 'HealthCheckEnveloped':
        """Returns the dict as a model

        :param dikt: A dict.
        :return: The HealthCheckEnveloped of this HealthCheckEnveloped.
        """
        return util.deserialize_model(dikt, cls)

    @property
    def data(self):
        """Gets the data of this HealthCheckEnveloped.


        :return: The data of this HealthCheckEnveloped.
        :rtype: InlineResponse200Data
        """
        return self._data

    @data.setter
    def data(self, data):
        """Sets the data of this HealthCheckEnveloped.


        :param data: The data of this HealthCheckEnveloped.
        :type data: InlineResponse200Data
        """
        if data is None:
            raise ValueError("Invalid value for `data`, must not be `None`")

        self._data = data

    @property
    def error(self):
        """Gets the error of this HealthCheckEnveloped.


        :return: The error of this HealthCheckEnveloped.
        :rtype: object
        """
        return self._error

    @error.setter
    def error(self, error):
        """Sets the error of this HealthCheckEnveloped.


        :param error: The error of this HealthCheckEnveloped.
        :type error: object
        """

        self._error = error