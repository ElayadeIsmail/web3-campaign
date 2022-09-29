import create from 'zustand';

interface CampaignStore {
    bears: number;
    increase: (by: number) => void;
}

const useCampaignStore = create<CampaignStore>((set) => ({
    bears: 0,
    increase: () => set((state) => ({ bears: state.bears + 1 })),
}));
