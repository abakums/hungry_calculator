import pytest

from users.factories import GroupFactory, ParticipantFactory, ParticipantGroupFactory

pytestmark = pytest.mark.django_db


class TestBulkCreate:

    endpoint = "/api/bill_positions/create/"

    def test_success(self, api_client):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory(name="Иван")
        self.participant_2 = ParticipantFactory(name="Петр")
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)
        ParticipantGroupFactory(participant=self.participant_2, group=self.group)
        self.data_to_create = {
            "groupId": self.group.group_uuid,
            "positions": [
                {
                    "title": "Position1",
                    "price": 100,
                    "parts": 1,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        }
                    ]
                },
                {
                    "title": "Position2",
                    "price": 300,
                    "parts": 3,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        },
                        {
                            "id": self.participant_2.id,
                            "personalPrice": 200,
                            "personalParts": 2
                        }
                    ]
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
        assert "positions" in response_data
        positions = response_data.get("positions")
        assert len(positions) == len(self.data_to_create.get("positions"))

    def test_without_group_id(self, api_client):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory(name="Иван")
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)

        self.data_without_group_id = {
            "positions": [
                {
                    "title": "Position1",
                    "price": 100,
                    "parts": 1,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        }
                    ]
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_without_group_id,
            format="json"
        )
        assert response.status_code == 400
        assert "groupId" in response.json()

    def test_without_title(self, api_client):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory(name="Иван")
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)

        self.data_without_title = {
            "groupId": self.group.group_uuid,
            "positions": [
                {
                    "price": 100,
                    "parts": 1,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        }
                    ]
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_without_title,
            format="json"
        )
        assert response.status_code == 400
        assert "title" in response.json().get("positions")[0]

    def test_without_parts(self, api_client):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory(name="Иван")
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)

        self.data_without_title = {
            "groupId": self.group.group_uuid,
            "positions": [
                {
                    "title": "Position1",
                    "price": 100,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                        }
                    ]
                }
            ]
        }

        response = api_client().post(
            self.endpoint,
            self.data_without_title,
            format="json"
        )
        assert response.status_code == 400
        assert "personalParts" in response.json().get("positions")[0].get("payers")[0]
        assert "parts" in response.json().get("positions")[0]
