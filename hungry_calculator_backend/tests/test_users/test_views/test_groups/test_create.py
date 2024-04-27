import pytest

from users.factories import GroupFactory, ParticipantFactory, ParticipantGroupFactory
from users.models import Group, Participant

pytestmark = pytest.mark.django_db


class TestCreate:

    endpoint = "/api/groups/create/"

    def test_success(self, api_client):
        self.creator = ParticipantFactory(name="Иван")

        self.data_to_create = {
            "title": "Group1",
            "requisites": "1234 5678 9012 1111",
            "creator": {
                "id": self.creator.id
            },
            "participants": [
                {
                    "name": "Петр"
                },
                {
                    "name": "Владислав"
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_to_create,
            format="json"
        )
        assert response.status_code == 201
        response_data = response.json()
        assert isinstance(response_data, dict)
        assert "participants" in response_data
        assert "groupId" in response_data
        group = Group.objects.get(title=self.data_to_create.get("title"))
        assert response_data.get("groupId") == group.group_uuid
        participant_names_from_data = [i.get("name") for i in self.data_to_create.get("participants")]
        participants = response_data.get("participants")
        assert isinstance(participants, list)
        assert len(participants) == len(self.data_to_create.get("participants"))
        for participant in participants:
            assert isinstance(participant, dict)
            assert "id" in participant
            assert "name" in participant
            assert participant.get("name") in participant_names_from_data
            assert Participant.objects.filter(id=participant.get("id"), name=participant.get("name")).exists()

    def test_without_title(self, api_client):
        self.creator = ParticipantFactory(name="Иван")

        self.data_to_create = {
            "requisites": "1234 5678 9012 1111",
            "creator": {
                "id": self.creator.id
            },
            "participants": [
                {
                    "name": "Петр"
                },
                {
                    "name": "Владислав"
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_to_create,
            format="json"
        )
        assert response.status_code == 400
        assert isinstance(response.json(), dict)
        assert "title" in response.json()

    def test_without_creator(self, api_client):
        self.data_to_create = {
            "title": "Group2",
            "requisites": "1234 5678 9012 1111",
            "participants": [
                {
                    "name": "Петр"
                },
                {
                    "name": "Владислав"
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_to_create,
            format="json"
        )
        assert response.status_code == 400
        assert isinstance(response.json(), dict)
        assert "creator" in response.json()

    def test_without_requisites(self, api_client):
        self.creator = ParticipantFactory(name="Константин")
        self.data_to_create = {
            "title": "Group3",
            "creator": {
                "id": self.creator.id
            },
            "participants": [
                {
                    "name": "Петр"
                },
                {
                    "name": "Владислав"
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_to_create,
            format="json"
        )
        assert response.status_code == 400
        assert isinstance(response.json(), dict)
        assert "requisites" in response.json()
