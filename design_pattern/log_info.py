import logging
import io

class Message:
    def __init__(self, name=''):
        self.messages = []
        self.name = name

    def write(self, msg):
        if msg != '\n':
            self.messages.append(msg)

    #def flush(self):
    #   self.messages.clear()

list_message = Message()
list_landler = logging.StreamHandler(list_message)


old_factory = logging.getLogRecordFactory()

def record_factory(*args, **kwargs):
    record = old_factory(*args, **kwargs)
    record.lines = lines
    record.expected = expected
    return record

logging.setLogRecordFactory(record_factory)

logger = logging.getLogger('first')
errors = io.StringIO()
formatter = logging.Formatter('%(levelname)s - %(message)s')
eh = logging.StreamHandler(errors)
eh.setFormatter(formatter)
logger.addHandler(eh)

logger.error("This is a test error message. %s", 'additional info')
logger.error("This is a se error message")
logger.error("This is a third error message")
contents=errors.getvalue()
print("error string=>{}".format(contents))
errors.close()


logger = logging.getLogger('second')
adaptor = logging.LoggerAdapter()