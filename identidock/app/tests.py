import unittest
import identidock

class TestCase(unittest.TestCase):
    def setUp(self):
        identidock.app.config["TESTING"] = True
        self.app = identidock.app.test_client()
    
    def testHelloWorld(self):
        page = self.app.get("/")
        assert page.status_code == 200
        assert "Hello Docker! 1,2,3" in str(page.data)
  
    def testGetMainPage(self):
        page = self.app.post("/index", data = dict(name = "Moby Dock"))
        assert page.status_code == 200
        assert "Hello" in str(page.data)
        assert "Moby Dock" in str(page.data)

    def testHtmlEscaping(self):
        page = self.app.post("/index", data = dict(name = '"><b>TEST</b><!--"'))
        assert "<b>" not in str(page.data)

if __name__ == "__main__":
    unittest.main()