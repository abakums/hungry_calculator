import pytest

from users.utils.groups import create_group
from users.factories import ParticipantFactory
from users.models import Group, Participant, ParticipantGroup

pytestmark = pytest.mark.django_db


class TestCreateGroup:
    def test_success(self):
        self.creator = ParticipantFactory()
        self.data_success = {
            "title": "Название группы 1",
            "creator": {"id": self.creator.id},
            "requisites": "1234 5678 9012 1234",
            "participants": [
                {"name": "Иван3"},
                {"name": "Владимир3"},
                {"name": "Константин3"}
            ]
        }

        group, participants = create_group(self.data_success)

        assert isinstance(group, Group)
        assert isinstance(participants, list)
        assert isinstance(participants[0], Participant)

        assert group.title == self.data_success.get("title")
        assert group.organizer == self.creator
        assert len(participants) == len(self.data_success.get("participants"))

        for i in range(len(self.data_success.get("participants"))):
            assert Participant.objects.filter(name=self.data_success.get("participants")[i].get("name")).count() == 1

        assert ParticipantGroup.objects.filter(is_organizer=True, participant=self.creator, group=group).exists()
        for participant in participants:
            assert ParticipantGroup.objects.filter(is_organizer=False, participant=participant, group=group).exists()

    def test_without_creator_and_participants(self):
        self.data_without_creator_and_participants = {
            "title": "Название группы 2",
            "requisites": "3210 0000 7654 1234",
            "participants": []
        }

        with pytest.raises(Exception):
            _, _ = create_group(self.data_without_creator_and_participants)

    def test_without_requisites(self):
        self.creator = ParticipantFactory()
        self.data_without_requisites = {
            "title": "Название группы 1",
            "creator": {"id": self.creator.id},
            "participants": [
                {"name": "Иван 2"},
                {"name": "Владимир 2"},
                {"name": "Константин 2"}
            ]
        }

        with pytest.raises(Exception):
            _, _ = create_group(self.data_without_requisites)
