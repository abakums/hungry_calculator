import random
from django.db import models


class Group(models.Model):
    title = models.CharField("Название", max_length=200)
    organizer = models.ForeignKey(
        "users.Participant",
        on_delete=models.CASCADE,
        verbose_name="Организатор",
        related_name="organizer_groups"
    )
    group_uuid = models.CharField("Уникальный ID", max_length=4, default="")
    requisites = models.CharField("Реквизиты", max_length=100)

    class Meta:
        verbose_name = "группу"
        verbose_name_plural = "Группы"

    def __str__(self):
        return self.title

    def save(self, *args, **kwargs):
        if not self.pk:
            self.group_uuid = str(random.randint(1000, 9999))
            while Group.objects.filter(group_uuid=self.group_uuid).exists():
                self.group_uuid = str(random.randint(1000, 9999))

        super().save(*args, **kwargs)

    def get_bill(self):
        payers = {}
        positions = self.bill_positions.all().prefetch_related("participant_bill_positions")
        for position in positions:
            participant_bill_positions = position.participant_bill_positions.all()
            for participant_bill_position in participant_bill_positions:
                if participant_bill_position.participant.id not in payers:
                    payers[participant_bill_position.participant.id] = []
                payers[participant_bill_position.participant.id].append(
                    {
                        "id": position.id,
                        "title": position.title,
                        "price": position.price,
                        "parts": position.parts,
                        "personalPrice": participant_bill_position.participant_price,
                        "personalParts": participant_bill_position.personal_parts
                    }
                )

        result = []
        for payer_id, positions in payers.items():
            price = sum([pos.get("personalPrice") for pos in positions])
            result.append(
                {
                    "payerId": payer_id,
                    "totalPrice": price,
                    "positions": positions
                }
            )
        return result


class Participant(models.Model):
    name = models.CharField("Имя", max_length=200)
    groups = models.ManyToManyField(
        "users.Group",
        blank=True,
        related_name="participants",
        verbose_name="Группы",
        through="ParticipantGroup",
        through_fields=("participant", "group", "is_organizer")
    )

    class Meta:
        verbose_name = "участника"
        verbose_name_plural = "Участники"

    def __str__(self):
        return self.name


class ParticipantGroup(models.Model):
    participant = models.ForeignKey(
        "users.Participant",
        on_delete=models.CASCADE,
        verbose_name="Участник",
        related_name="participant_groups"
    )
    group = models.ForeignKey(
        "users.Group",
        on_delete=models.CASCADE,
        verbose_name="Группа",
        related_name="participant_groups"
    )
    is_organizer = models.BooleanField("Является организатором", default=False)

    class Meta:
        verbose_name = "участника группы"
        verbose_name_plural = "Участники групп"

    def __str__(self):
        return f"{self.participant} - {self.group}"
