class Hidden(object):
    pass


class Whatever(object):

    def __init__(self):
        self.h = None

    def action(self):
        print('action start')
        self.h = Hidden()
        print('action end')
