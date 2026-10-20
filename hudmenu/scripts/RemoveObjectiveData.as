package
{
   public class RemoveObjectiveData
   {
      
      private var m_OwningQuest:HUDQuestTrackerEntry;
      
      private var m_ObjectiveToRemove:HUDQuestTrackerObjective;
      
      public function RemoveObjectiveData(aObjectiveToRemove:HUDQuestTrackerObjective, aOwningQuest:HUDQuestTrackerEntry)
      {
         super();
         this.m_OwningQuest = aOwningQuest;
         this.m_ObjectiveToRemove = aObjectiveToRemove;
      }
      
      public function get owningQuest() : HUDQuestTrackerEntry
      {
         return this.m_OwningQuest;
      }
      
      public function get objectiveToRemove() : HUDQuestTrackerObjective
      {
         return this.m_ObjectiveToRemove;
      }
   }
}

