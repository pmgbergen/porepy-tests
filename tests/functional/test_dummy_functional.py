""""
This module contains dummy functional tests meant for setting up the testing workflow.
"""

import porepy as pp
import pytest
import numpy as np


class TestDummy:

    def __init__(self):
        pass

    def test_dummy_one(self):
        """Just a simple dummy test"""
        assert 1 + 1 == 2

    def test_dummy_two(self):
        """Another dummy test"""
        assert 1 + 2 == 3

    def test_dummy_three(self):
        """Yet another dummy test"""
        assert 3 * 3 == 9