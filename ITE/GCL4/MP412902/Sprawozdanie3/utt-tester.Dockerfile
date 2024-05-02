ARG BUILDER-VERSION

FROM utt-builder:${BUILDER-VERSION}
RUN pip install pytest
RUN pytest test/unit/test_report.py