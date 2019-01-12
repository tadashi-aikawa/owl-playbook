#!/usr/bin/env python
# -*- coding:utf-8 -*-

import pytest


class Test:
    @pytest.mark.parametrize(
        'title, expected, params', [
            ('title', 'expected', 'params'),
        ]
    )
    def test_normal(self, title, expected, params):
        actual = xxx
        assert expected == actual

