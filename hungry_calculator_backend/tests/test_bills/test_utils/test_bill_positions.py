import pytest
from bills.utils.bill_positions import create_bill_positions
from bills.models import ParticipantBillPosition, BillPosition
from users.factories import GroupFactory, ParticipantFactory, ParticipantGroupFactory

pytestmark = pytest.mark.django_db


class TestCreateBillPositions:
    def test_success(self):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory(name="Иван")
        self.participant_2 = ParticipantFactory(name="Владимир")
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)
        ParticipantGroupFactory(participant=self.participant_2, group=self.group)
        self.data_success = {
            "positions": [
                {
                    "title": "Title1",
                    "price": 200,
                    "parts": 2,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        },
                        {
                            "id": self.participant_2.id,
                            "personalPrice": 100,
                            "personalParts": 1
                        }
                    ]
                },
                {
                    "title": "Title2",
                    "price": 500,
                    "parts": 1,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 500,
                            "personalParts": 1
                        },
                    ]
                },
                {
                    "title": "Title3",
                    "price": 500,
                    "parts": 5,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalPrice": 300,
                            "personalParts": 3
                        },
                        {
                            "id": self.participant_2.id,
                            "personalPrice": 200,
                            "personalParts": 2
                        }
                    ]
                },
            ],
            "groupId": self.group.group_uuid
        }

        result = create_bill_positions(self.data_success)

        assert isinstance(result, dict)
        assert "positions" in result
        positions = result.get("positions")
        assert isinstance(positions, list)
        assert len(positions) == 3
        position_titles = {i.get("title") for i in self.data_success.get("positions")}
        bill_positions_ids = []
        for position in positions:
            assert isinstance(position, dict)
            assert "id" in position
            assert "title" in position
            assert position.get("title") in position_titles
            bill_positions_ids.append(position.get("id"))

        for bill_positions_id in bill_positions_ids:
            assert BillPosition.objects.filter(id=bill_positions_id).exists()
            bill_position = BillPosition.objects.get(id=bill_positions_id)
            title = bill_position.title
            participants = [i.get("payers") for i in self.data_success.get("positions") if i.get("title") == title][0]
            assert ParticipantBillPosition.objects.filter(bill_position=bill_position).count() == len(participants)

    def test_without_group_id(self):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory()
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)

        self.data_without_group_id = {
            "positions": [
                {
                    "title": "Title1",
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
        with pytest.raises(Exception):
            _ = create_bill_positions(self.data_without_group_id)

    def test_without_personal_price(self):
        self.group = GroupFactory()
        self.participant_1 = ParticipantFactory()
        ParticipantGroupFactory(participant=self.participant_1, group=self.group, is_organizer=True)

        self.data_without_personal_price = {
            "positions": [
                {
                    "title": "Title1",
                    "price": 100,
                    "parts": 1,
                    "payers": [
                        {
                            "id": self.participant_1.id,
                            "personalParts": 1
                        }
                    ]
                }
            ]
        }
        with pytest.raises(Exception):
            _ = create_bill_positions(self.data_without_personal_price)
