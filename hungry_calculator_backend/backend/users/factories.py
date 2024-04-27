import factory.fuzzy
from django.conf import settings

from users.models import Group, Participant, ParticipantGroup

factory.Faker._DEFAULT_LOCALE = settings.LANGUAGE_CODE


class GroupFactory(factory.django.DjangoModelFactory):
    title = factory.fuzzy.FuzzyText(length=100)
    organizer = factory.SubFactory("users.factories.ParticipantFactory")
    requisites = factory.fuzzy.FuzzyText(length=15)

    class Meta:
        model = Group


class ParticipantFactory(factory.django.DjangoModelFactory):
    name = factory.Faker("first_name_male")

    @factory.post_generation
    def groups(self, create, extracted, **kwargs):
        if not create:
            return

        if extracted:
            for group in extracted:
                self.groups.add(group)

    class Meta:
        model = Participant


class ParticipantGroupFactory(factory.django.DjangoModelFactory):
    participant = factory.SubFactory("users.factories.ParticipantFactory")
    group = factory.SubFactory("bot.factories.GroupFactory")
    is_organizer = False

    class Meta:
        model = ParticipantGroup
        django_get_or_create = ("group", "participant")
