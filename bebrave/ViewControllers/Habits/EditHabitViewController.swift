//
//  ChangeHabitViewController.swift
//  bebrave
//
//  Created by Anastasia Tyutinova on 2/1/2568 BE.
//

import UIKit

final class EditHabitViewController: BaseHabitViewController {

    var habitToEdit: Habit?

    // MARK: - Init

    init(habit: Habit) {
        self.habitToEdit = habit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        guard let habit = habitToEdit else { return }
        habitTextField.text = habit.title
        timesPerDayTextField.text = "\(habit.frequency)"
        selectedDays = habit.daysOfWeek
        setupDaysOfWeekStack()
        monthsTextField.text = "\(habit.monthFrequency)"

        didSaveNewHabitButton.configuration?.baseBackgroundColor = AppStyle.Colors.primaryGreenColor
        didSaveNewHabitButton.setTitle("Сохранить изменения", for: .normal)
        didSaveNewHabitButton.addTarget(self, action: #selector(saveHabit), for: .touchUpInside)
    }

    // MARK: - Handle performing habit

    override func handleHabitSave(_ habit: Habit) {
        var updatedHabit = habit
        updatedHabit.daysOfWeek = selectedDays
        updatedHabit.updateSkippedDays(startDate: updatedHabit.creationDate, endDate: Date())

        delegate?.didEditHabit(habit)
        print("Изменённая привычка сохранена: \(updatedHabit.title)")
        self.dismiss(animated: true, completion: nil)
    }

    override func createHabitFromFields() -> Habit? {
        guard let title = habitTextField.text,
              let frequencyText = timesPerDayTextField.text,
              let frequency = Int(frequencyText),
              let monthFrequencyText = monthsTextField.text,
              let monthFrequency = Int(monthFrequencyText),
              let habitToEdit = habitToEdit else {
            return nil
        }

        return Habit(
            id: habitToEdit.id,
            title: title,
            frequency: frequency,
            monthFrequency: monthFrequency,
            daysOfWeek: selectedDays,
            progress: habitToEdit.progress,
            skipDates: habitToEdit.skipDates,
            creationDate: habitToEdit.creationDate
        )
    }
}
