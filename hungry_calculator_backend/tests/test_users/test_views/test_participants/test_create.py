import pytest

from users.models import Participant


pytestmark = pytest.mark.django_db


class TestCreate:

    endpoint = "/api/participants/create/"

    def test_success(self, api_client):
        self.data = {
            "name": "Новый participant"
        }

        response = api_client().post(
            self.endpoint,
            self.data,
            format="json"
        )
        assert response.status_code == 201
        response_data = response.json()
        assert isinstance(response_data, dict)
        assert "id" in response_data
        assert Participant.objects.filter(name=self.data.get("name")).exists()
        participant = Participant.objects.get(name=self.data.get("name"))
        assert response_data.get("id") == participant.id

    def test_without_name(self, api_client):
        self.data_without_name = {}

        response = api_client().post(self.endpoint)
        assert response.status_code == 400
        data = response.json()
        assert isinstance(data, dict)
        assert "name" in data
