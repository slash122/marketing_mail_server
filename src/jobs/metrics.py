from src.base_job import EmailJob
import re

class MetricsJob(EmailJob):
    async def run(self):
        result = {}
        result['word_count'] = len(self.text.split())
        result['char_count'] = len(self.text)
        result['line_count'] = len(self.text.splitlines())
        result['paragraph_count'] = len(self.text.split('\n\n'))
        result['sentence_count'] = self.text.count('.') + self.text.count('!') + self.text.count('?')
        result['average_word_length'] = self.average_word_length(result)
        result['reading_time_seconds'] = (result['word_count'] / 200) * 60 
        result['uppercase_ratio'] = self.get_uppercase_ratio()
        result['digit_ratio'] = self.get_digit_ratio()
        result['special_char_ratio'] = self.get_special_char_ratio()
        result['link_count'] = len(self.etree.xpath('//a/@href'))
        result['email_mentions'] = len(re.findall(r'[\w\.-]+@[\w\.-]+\.\w+', self.text))
        result['vocabulary_richness'] = self.get_vocabulary_richness(result['word_count'])
        return result

    def average_word_length(self, result) -> float:
        if result['word_count'] == 0: return 0
        return sum(len(word) for word in self.text.split()) / result['word_count']

    def get_uppercase_ratio(self) -> float:
        if not self.text: return 0.0
        return sum(1 for c in self.text if c.isupper()) / len(self.text)

    def get_digit_ratio(self) -> float:
        if not self.text: return 0.0
        return sum(1 for c in self.text if c.isdigit()) / len(self.text)

    def get_special_char_ratio(self) -> float:
        if not self.text: return 0.0
        return sum(1 for c in self.text if not c.isalnum() and not c.isspace()) / len(self.text)

    def get_vocabulary_richness(self, word_count) -> float:
        if word_count == 0: return 0.0
        unique_words = len(set(self.text.lower().split()))
        return unique_words / word_count