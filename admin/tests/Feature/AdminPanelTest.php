<?php

namespace Tests\Feature;

use App\Filament\Resources\Contributions\Pages\ListContributions;
use App\Filament\Resources\Memorials\Pages\ListMemorials;
use App\Models\Contribution;
use App\Models\Memorial;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * The admin panel exists to curate the registry, so the parts worth testing are
 * that it shows what is waiting and that publishing a letter actually publishes.
 */
class AdminPanelTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAs(User::factory()->create());
    }

    private function memorial(string $id = 'albert-einstein'): Memorial
    {
        $memorial = new Memorial(['id' => $id]);
        $memorial->id = $id;
        $memorial->syncFromDocument([
            'id' => $id,
            'slug' => $id,
            'fullName' => 'Albert Einstein',
            'privacy' => 'public',
        ]);
        $memorial->save();

        return $memorial;
    }

    public function test_the_panel_requires_a_login(): void
    {
        auth()->logout();

        $this->get('/admin')->assertRedirect();
    }

    public function test_it_lists_dossiers(): void
    {
        $memorial = $this->memorial();

        \Livewire\Livewire::test(ListMemorials::class)
            ->assertCanSeeTableRecords([$memorial]);
    }

    public function test_it_shows_letters_awaiting_a_decision(): void
    {
        $memorial = $this->memorial();

        $pending = $memorial->contributions()->create([
            'kind' => 'memory',
            'author_name' => 'Bir Ziyaretçi',
            'body' => 'Onu hiç unutmadım.',
            'is_approved' => false,
        ]);

        \Livewire\Livewire::test(ListContributions::class)
            ->assertCanSeeTableRecords([$pending]);
    }

    public function test_publishing_a_letter_makes_it_public(): void
    {
        $memorial = $this->memorial();

        $pending = $memorial->contributions()->create([
            'kind' => 'memory',
            'author_name' => 'Bir Ziyaretçi',
            'body' => 'Onu hiç unutmadım.',
            'is_approved' => false,
        ]);

        \Livewire\Livewire::test(ListContributions::class)
            ->callAction(
                \Filament\Actions\Testing\TestAction::make('approve')->table($pending)
            );

        $this->assertTrue($pending->refresh()->is_approved);
    }

    public function test_the_pending_count_is_shown_in_the_navigation(): void
    {
        $memorial = $this->memorial();

        $memorial->contributions()->create([
            'kind' => 'memory',
            'body' => 'Waiting.',
            'is_approved' => false,
        ]);

        $this->assertSame(
            '1',
            \App\Filament\Resources\Contributions\ContributionResource::getNavigationBadge()
        );

        // A candle is published on arrival and must not show as pending.
        $memorial->contributions()->create(['kind' => 'candle', 'is_approved' => true]);

        $this->assertSame(
            '1',
            \App\Filament\Resources\Contributions\ContributionResource::getNavigationBadge()
        );
    }

    public function test_contribution_count_is_ignored_when_none_are_pending(): void
    {
        $this->memorial()->contributions()->create(['kind' => 'candle', 'is_approved' => true]);

        $this->assertNull(
            \App\Filament\Resources\Contributions\ContributionResource::getNavigationBadge()
        );
    }
}
