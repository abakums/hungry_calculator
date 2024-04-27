import pytest

from users.utils.participants import create_participant
from users.models import Participant

pytestmark = pytest.mark.django_db


class TestCreateParticipant:
    def test_success(self):
        self.success_data = {
            "name": "Иван"
        }
        participant = create_participant(self.success_data)

        assert isinstance(participant, Participant)
        assert participant.name == self.success_data.get("name")

    def test_with_long_name(self):
        self.data_with_long_name = {
            "name": "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
                    "ИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИванИван"
        }
        with pytest.raises(Exception):
            _ = create_participant(self.data_with_long_name)

    def test_without_name(self):
        self.data_without_name = {
            "nam": "Иван"
        }
        with pytest.raises(Exception):
            _ = create_participant(self.data_without_name)
