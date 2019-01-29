import unittest
from cnns.nnlib.utils.log_utils import set_up_logging
from cnns.nnlib.utils.log_utils import get_logger
import logging
import torch
import numpy as np
from cnns.nnlib.dct.simple_dct import DCT

class TestSimpleDCT(unittest.TestCase):

    def setUp(self):
        print("\n")
        log_file = "test_simple_dct.log"
        is_debug = True
        set_up_logging(log_file=log_file, is_debug=is_debug)
        self.logger = get_logger(name=__name__)
        self.logger.setLevel(logging.DEBUG)
        self.logger.info("Set up test")
        seed = 31
        if torch.cuda.is_available():
            self.device = torch.device("cuda")
            print("cuda is available")
            torch.cuda.manual_seed_all(seed)
        else:
            self.device = torch.device("cpu")
            print("cuda is not available")
            torch.manual_seed(seed)
        self.dtype = torch.float
        self.ERR_MESSAGE_ALL_CLOSE = "The expected array desired and " \
                                     "computed actual are not almost equal."

    def testCorrelation1(self):
        x = np.array([1,2,3], dtype=float)
        y = np.array([-1,2], dtype=float)
        dct = DCT()
        expect = np.correlate(x, y)
        print("expect: ", expect)
        result = dct.correlate(x, y)
        print("result: ", result)
        assert np.testing.assert_allclose(actual=result, desired=expect)