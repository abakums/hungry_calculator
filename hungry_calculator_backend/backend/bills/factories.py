import factory.fuzzy
from django.conf import settings

from bills.models import ParticipantBillPosition, BillPosition

factory.Faker._DEFAULT_LOCALE = settings.LANGUAGE_CODE


class ParticipantBillPositionFactory(factory.django.DjangoModelFactory):
    bill_position = factory.SubFactory("bills.factories.BillPositionFactory")
    participant = factory.SubFactory("users.factories.ParticipantFactory")
    participant_price = factory.fuzzy.FuzzyInteger(100, 1000)

    class Meta:
        model = BillPosition
        django_get_or_create = ("bill_position", "participant")


class BillPositionFactory(factory.django.DjangoModelFactory):
    title = factory.fuzzy.FuzzyText(length=100)
    price = factory.fuzzy.FuzzyInteger(100, 10000)
    group = factory.SubFactory("bot.factories.GroupFactory")

    @factory.post_generation
    def participants(self, created, extracted, **kwargs):
        if not created:
            return

        if extracted:
            for participant in extracted:
                self.participants.add(participant)

    class Meta:
        model = ParticipantBillPosition
