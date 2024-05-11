ARG BUILDER_VERSION

FROM utt-builder:${BUILDER_VERSION}
RUN pip install pytest
RUN pytest test/unit/test_report.py