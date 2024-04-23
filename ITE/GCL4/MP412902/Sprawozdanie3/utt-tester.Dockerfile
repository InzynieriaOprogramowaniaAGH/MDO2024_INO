FROM utt-builder
RUN pip install pytest
RUN pytest test/unit/test_report.py