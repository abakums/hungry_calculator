import pytest

from users.factories import GroupFactory


pytestmark = pytest.mark.django_db


class TestGet:

    endpoint = "/api/groups/get/"

    def test_success(self, api_client):
        self.group = GroupFactory()

        response = api_client().get(
            f"{self.endpoint}{self.group.group_uuid}/"
        )
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, dict)
        assert "bill" in data
        assert "creator" in data
        assert "participants" in data
        assert "requisites" in data
        assert "title" in data
        assert data.get("title") == self.group.title
        assert data.get("requisites") == self.group.requisites
        participants = data.get("participants")
        assert isinstance(participants, list)
        assert participants == []
        creator = data.get("creator")
        assert isinstance(creator, dict)
        assert "id" in creator
        assert creator.get("id") == self.group.organizer.id
        bill = data.get("bill")
        assert isinstance(bill, list)
        assert bill == []

    def test_group_not_exists(self, api_client):
        response = api_client().get(
            f"{self.endpoint}rergbrtyrtyvweqwe/"
        )
        assert response.status_code == 404
        data = response.json()
        assert isinstance(data, dict)
